 
#ifndef _FORMAT_CONFIG_PLUGIN_H_
#define _FORMAT_CONFIG_PLUGIN_H_

#include <QDesignerCustomWidgetInterface>

class FormatConfigPlugin : public QObject, public QDesignerCustomWidgetInterface
{
	Q_OBJECT
	Q_INTERFACES(QDesignerCustomWidgetInterface)
	
	public:
		FormatConfigPlugin(QObject *p = 0);
		
		bool isContainer() const;
		bool isInitialized() const;
		QIcon icon() const;
		QString domXml() const;
		QString group() const;
		QString includeFile() const;
		QString name() const;
		QString toolTip() const;
		QString whatsThis() const;
		QWidget *createWidget(QWidget *p);
		void initialize(QDesignerFormEditorInterface *core);
		
	private:
		bool m_initialized;
};

#endif // _FORMAT_CONFIG_PLUGIN_H_
