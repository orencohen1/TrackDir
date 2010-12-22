function tabledit_actions( action )

global yfig TablesData x 

switch( action ),
    
    case 'ADD',
        L = size(TablesData,1);
        TablesDataNew = TablesData;
        
        TablesDataNew{L+1,1} = '';
        TablesDataNew{L+1,2} = '';
        set(yfig.handles.TableEdit,'Data', TablesDataNew);
        %         set(yfig.handles.TableEdit,'Value', L);
        
        % %     case 'DEL',
        % %         pos = get(yfig.handles.TableEdit,'Value');
        % %         L = size(TablesData,1);
        % %         pointers = ones(size(L),1);
        % %         pointers(pos)=0;
        % %         TablesDataNew = TablesData{find(pointers),:};
        % %         set(yfig.handles.TableEdit,'Data', TablesDataNew);
    case 'APPLY',
        TablesData = get(yfig.handles.TableEdit,'Data');
        TablesData = remove_empty_rows( TablesData );
        
        set(yfig.main,'Visible', 'off');
        set(x.handles.MonkeySel,'Value',1);
        set(x.handles.MonkeySel,'String',TablesData(:,1));

    case 'CANCEL',
        set(yfig.handles.TableEdit,'Data', TablesData);
        close(yfig.main);
             
end


function  TablesData = remove_empty_rows( TablesData )

L = size(TablesData,1);
pointer = ones(L,1);
for i=1:L,
    if isempty(TablesData{i,1}) & isempty(TablesData{i,2}),
        pointer(i) = 0;
    end
end

TablesData = TablesData(find(pointer),:);




        