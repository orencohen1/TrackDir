function TrackDirGui( )
global x yfig TablesData

x.main=openfig('TrackDirYP.fig');
x.handles=guihandles(x.main);
x.filepath='F:\Hugo\HugoCorticalData\EdFiles\'

load TablesData
set(x.handles.MonkeySel,'Value',1);
set(x.handles.MonkeySel,'String',TablesData(:,1));

monkeyindx = get(x.handles.MonkeySel,'Value');
[x.table, names] = get_table( monkeyindx );
set( x.handles.TableEntry,'String', names);
set( x.handles.TableEntry,'Value', 1);
spikes = get_sp_list( x.table, 1);
set(x.handles.SpikeEntry, 'String', spikes);
set(x.handles.SpikeEntry, 'Value', 1);

