function edit_table_data( )

global yfig TablesData

yfig.main = openfig('TablEdit.fig');
yfig.handles=guihandles(yfig.main);
set(yfig.main,'Visible', 'on');
set(yfig.handles.TableEdit,'Data', TablesData);

