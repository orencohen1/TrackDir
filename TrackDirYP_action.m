function TrackDirYP_action(action )


global x

switch( action )
    case 'monkeysel',
        monkeyindx = get(x.handles.MonkeySel,'Value');
        [x.table, names] = get_table( monkeyindx );
        set( x.handles.TableEntry,'String', names);
        set( x.handles.TableEntry,'Value', 1);
        spikes = get_sp_list( x.table, 1);
        set(x.handles.SpikeEntry, 'String', spikes);
        set(x.handles.SpikeEntry, 'Value', 1);
        TrackDirYP_action('tablesel' )
        TrackDirYP_action('spikesel' )

        
        tableindx = get(x.handles.TableEntry,'Value');
        spikeindx = get(x.handles.SpikeEntry,'Value');
        includestring = get_include_field( x.table, tableindx, spikeindx);
        set( x.handles.IncludeTag,'String', includestring);

    case 'tablesel',
        tableindx = get(x.handles.TableEntry,'Value');
        spikes = get_sp_list( x.table, tableindx);
        set(x.handles.SpikeEntry, 'String', spikes);
        set(x.handles.SpikeEntry, 'Value', 1);

        TrackDirYP_action('spikesel' )

        spikeindx = get(x.handles.SpikeEntry,'Value');
        includestring = get_include_field( x.table, tableindx, spikeindx);
        set( x.handles.IncludeTag,'String', includestring);

    case 'spikesel',
        tableindx = get(x.handles.TableEntry,'Value');
        spikeindx = get(x.handles.SpikeEntry,'Value');
        includestring = get_include_field( x.table, tableindx, spikeindx);
        set( x.handles.IncludeTag,'String', includestring);
end

