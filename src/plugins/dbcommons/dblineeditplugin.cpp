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

#include "dblineeditplugin.h"
#include "widgets/dblineedit.h"

DBLineEditPlugin::DBLineEditPlugin(QObject *parent) :
    QObject(parent)
{
	m_initialized = false;
}

void DBLineEditPlugin::initialize(QDesignerFormEditorInterface * /* core */)
{
	if ( m_initialized ) {
		return;
	}
	m_initialized = true;
 }

bool DBLineEditPlugin::isInitialized() const
{
	return m_initialized;
}

QWidget *DBLineEditPlugin::createWidget(QWidget *parent)
{
	return new DBLineEdit(parent);
}

QString DBLineEditPlugin::name() const
{
	return "DBLineEdit";
}

QString DBLineEditPlugin::group() const
{
	return "PrintingERP";
}

QIcon DBLineEditPlugin::icon() const
{
	return QIcon(":/images/dblineedit.png");
}

QString DBLineEditPlugin::toolTip() const
{
	return trUtf8("QLineEdit que lee de base de datos, interactuando a través de objetos BaseBean");
}

QString DBLineEditPlugin::whatsThis() const
{
	return trUtf8("QLineEdit que lee de base de datos, interactuando a través de objetos BaseBean");
}

bool DBLineEditPlugin::isContainer() const
{
	return false;
}

QString DBLineEditPlugin::domXml() const
{
 return "<ui language=\"c++\">\n"
		" <widget class=\"DBLineEdit\" name=\"dbLineEdit\">\n"
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

QString DBLineEditPlugin::includeFile() const
{
	return "widgets/dblineedit.h";
}
