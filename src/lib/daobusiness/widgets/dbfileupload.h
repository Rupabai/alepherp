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
#ifndef DBFILEUPLOAD_H
#define DBFILEUPLOAD_H

#include <QWidget>
#include <QScriptValue>
#include <alepherpglobal.h>
#include "widgets/dbbasewidget.h"
#include "dao/observerfactory.h"

namespace Ui {
	class DBFileUpload;
}

class DBFileUploadPrivate;

/**
  Permite subir imágenes al sistema.
  */
class Q_ALEPHERP_EXPORT DBFileUpload : public QWidget, public DBBaseWidget
{
    Q_OBJECT
	Q_PROPERTY (QString fieldName READ fieldName WRITE setFieldName)
	Q_PROPERTY (QString relationFilter READ relationFilter WRITE setRelationFilter)
	Q_PROPERTY (bool dataEditable READ dataEditable WRITE setDataEditable)
	Q_PROPERTY (bool perpControl READ perpControl)
	Q_PROPERTY (bool userModified READ userModified WRITE setUserModified)
	Q_PROPERTY (QVariant value READ value WRITE setValue)
	/** Un control puede estar dentro de un PERPScriptWidget. ¿De dónde lee los datos? Los puede leer
	  del bean asignado al propio PERPScriptWidget, o bien, leerlos del bean del formulario base
	  que lo contiene. Esta propiedad marca esto */
	Q_PROPERTY (bool dataFromParentDialog READ dataFromParentDialog WRITE setDataFromParentDialog)
	/** Nombre del group box que envuelve el control */
	Q_PROPERTY (QString groupName READ groupName WRITE setGroupName)

protected:
	void showEvent(QShowEvent *event) { DBBaseWidget::showEvent(event); QWidget::showEvent(event); }
	void hideEvent(QHideEvent *event) { DBBaseWidget::hideEvent(event); QWidget::hideEvent(event); }

public:
	explicit DBFileUpload(QWidget *parent = 0);
	~DBFileUpload();

	int observerType() { return OBSERVER_DBFIELD; }

	void setGroupName(const QString &name);
	QString groupName();
	QVariant value();
	void clear();
	void applyFieldProperties();

	static QScriptValue toScriptValue(QScriptEngine *engine, DBFileUpload * const &in);
	static void fromScriptValue(const QScriptValue &object, DBFileUpload * &out);

public slots:
	void setValue(const QVariant &value);
	void observerUnregistered();
	void refresh();

private slots:
	void pbUploadClicked();
	void pbDeleteClicked();

signals:
	void valueEdited(const QVariant &value);
	void destroyed(QWidget *widget);

private:
	Ui::DBFileUpload *ui;
	DBFileUploadPrivate *d;
	Q_DECLARE_PRIVATE(DBFileUpload)
};

Q_DECLARE_METATYPE(DBFileUpload*)
Q_SCRIPT_DECLARE_QMETAOBJECT(DBFileUpload, DBFileUpload*)

#endif // DBFILEUPLOAD_H
