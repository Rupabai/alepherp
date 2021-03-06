/***************************************************************************
 *   Copyright (C) 2011 by David Pinelo   *
 *   david.pinelo@alephsistemas.es   *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

#include "dbcomboboxplugin.h"
#include "widgets/dbcombobox.h"
#include <QtPlugin>

DBComboBoxPlugin::DBComboBoxPlugin(QObject *parent) : QObject (parent)
{
	m_initialized = false;
	m_combo = NULL;
}

void DBComboBoxPlugin::initialize(QDesignerFormEditorInterface * /* core */)
{
	if ( m_initialized ) {
		return;
	}

	m_initialized = true;
 }

bool DBComboBoxPlugin::isInitialized() const
{
	return m_initialized;
}

QWidget *DBComboBoxPlugin::createWidget(QWidget *parent)
{
	m_combo = new DBComboBox(parent);
	return m_combo;
}

QString DBComboBoxPlugin::name() const
{
	return "DBComboBox";
}

QString DBComboBoxPlugin::group() const
{
	return "PrintingERP";
}

QIcon DBComboBoxPlugin::icon() const
{
	return QIcon(":/images/dbcombobox.png");
}

QString DBComboBoxPlugin::toolTip() const
{
	return trUtf8("ComboBox que lee de base de datos, interactuando a través de objetos BaseBean");
}

QString DBComboBoxPlugin::whatsThis() const
{
	return trUtf8("ComboBox que lee de base de datos, interactuando a través de objetos BaseBean");
}

bool DBComboBoxPlugin::isContainer() const
{
	return false;
}

QString DBComboBoxPlugin::domXml() const
{
 return "<ui language=\"c++\">\n"
		" <widget class=\"DBComboBox\" name=\"dbComboBox\">\n"
		"  <property name=\"geometry\">\n"
		"   <rect>\n"
		"    <x>0</x>\n"
		"    <y>0</y>\n"
		"    <width>100</width>\n"
		"    <height>25</height>\n"
		"   </rect>\n"
		"  </property>\n"
		" </widget>\n"
		"</ui>";
}

QString DBComboBoxPlugin::includeFile() const
{
	return "widgets/dbcombobox.h";
}
