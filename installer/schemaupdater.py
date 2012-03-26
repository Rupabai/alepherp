# encoding: UTF-8
from StringIO import StringIO
from lxml import etree
from inst_utils import Struct
import db_postgresql as pginspect

def parseTable(nombre, contenido, encoding = "UTF-8", remove_blank_text = True):
    file_alike = StringIO(contenido)

    parser = etree.XMLParser(
                    ns_clean=True,
                    encoding=encoding,
                    recover=False,
                    remove_blank_text=remove_blank_text,
                    )
    tree = etree.parse(file_alike, parser)
    root = tree.getroot()
    
    objname = root.xpath("name")[0]
    if objname.text != nombre: 
        print "WARN: Nombre de tabla %s no coincide con el nombre declarado en el XML %s (se prioriza el nombre de tabla)" % (objname.text,nombre)
        objname.text = nombre
    return getTableObj(tree,root)
    
def getTableObj(tree,root):
    table = Struct()
    table.xmltree = tree
    table.xmlroot = root
    table.name = table.xmlroot.xpath("name/text()")[0]
    table.fields = []
    table.pk = []
    table.fields_idx = {}
    for xmlfield in table.xmlroot.xpath("field"):
        field = Struct()
        field.name = xmlfield.xpath("name/text()")[0]
        build_field_type(field, xmlfield)
        field.pk = text2bool(one(xmlfield.xpath("pk/text()"),"false"))
        field.default = one(xmlfield.xpath("default/text()"),None)
        if field.pk: table.pk.append(field.name)
        if field.name in table.fields_idx: raise ValueError("La tabla %s tiene el campo %s repetido" % (table.name,field.name))
        field.number = len(table.fields)
        table.fields_idx[field.name] = field.number
        table.fields.append(field)
    return table

def text2bool(text):
    text = text.strip().lower()
    if text.startswith("t"): return True
    if text.startswith("f"): return False
    
    if text.startswith("y"): return True
    if text.startswith("n"): return False

    if text.startswith("1"): return True
    if text.startswith("0"): return False
    
    if text == "on": return True
    if text == "off": return False

    if text.startswith("s"): return True
    raise ValueError("Valor booleano no comprendido '%s'" % text)

def one(listobj, default = None):
    try: return listobj[0]
    except IndexError: return default
    

def update_table(conn, table):
    cur = conn.cursor()
    dbfields = {}
    otable = pginspect.get_relname_oid(conn, table.name)
    print "Table:", otable.namespace, otable.name
    for ocol in pginspect.get_table_columns(conn, otable):
        dbfields[ocol.name] = ocol
        
    for field in table.fields:
        ocol = dbfields.get(field.name,None)
        print "Field:", field.name, "|", field.sql_type, "|", field.sql_nullable, "|", field.default
        if ocol is None:
            # TODO: Agregar el campo
            try:
                cur.execute("""ALTER TABLE "%s" ADD COLUMN "%s" %s """ % (otable.name, field.name, field.sql_definition))
            except Exception, e:
                print "ALTER TABLE ERROR::" , e
            continue
        pginspect.field2serial(ocol)
        print "Column:", ocol.name, "|", ocol.format_type, "|", ocol.sql_nullable, "|", ocol.format_extra
    print
    
    
    
    
def create_table(conn, table):
    cur = conn.cursor()
    field_sql_list = [ "%s %s" % (field.name,field.sql_definition) 
                        for field in table.fields ]
    if table.pk:
        field_sql_list.append("PRIMARY KEY (" + ", ".join(table.pk) + ")")
    
    cur.execute("""
    CREATE TABLE %s (
        %s
    )
    """ % (table.name, ",\n".join(field_sql_list)))
    

def build_field_type(field, xmlfield):
    typetr={
        'string'    : 'character varying',
        'double'    : 'double precision',
        'number'    : 'integer',
        'int'       : 'integer',
        'uint'      : 'integer',
        'unit'      : 'smallint',
        'stringlist': 'text',
        'pixmap'    : 'text',
        'unlock'    : 'boolean',
        'serial'    : 'serial',
        'bool'      : 'bool',
        'date'      : 'date',
        'time'      : 'time',
        'bytearray' : 'bytea',
    }
    field.mtd_type = one(xmlfield.xpath("type/text()"),"string")
    field.nullable = text2bool(one(xmlfield.xpath("null/text()"),"true"))
    field.length = int(one(xmlfield.xpath("length/text()"),"64"))
    field.sql_type = typetr.get(field.mtd_type,field.mtd_type)
    if field.sql_type == "character varying": field.sql_type += "(%d)" % field.length
    field.sql_nullable = "" if field.nullable else "NOT NULL"
    field.sql_definition = field.sql_type
    if field.sql_nullable: field.sql_definition+=" " + field.sql_nullable
