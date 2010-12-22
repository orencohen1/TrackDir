function [table, lnames] = get_table( monkeyindx )

global TablesData x

curtablefile = TablesData{monkeyindx,1};
vrnames=who('-file',curtablefile );
if isempty(find(strcmp(vrnames,'table'))),
    errordlg(['In table file ' curtablefile '--> no table awas found!'],'TableError');
    table = x.table;
     lnames = get( x.handles.TableEntry,'String');
     return
end



load(curtablefile);

% load AllTablesNmaps
% 
% switch monkeyindx, 
%     case 1,
%         table = dtable;
%     case 2,
%         table = gtable;
%     case 3,
%         %         table = vtable4yifat1;
%         table = vtable;
%     case 4,
%         table = SCTtable;
%     case 5,
%         table = vtable4yifat1;
%     case 6,
%         load HugoTable;
% 	case 7,
% 		load SCTtable_all
% 		table = SCTtable_edited;
%     case 8,
%         load HugoScp;
%         table = HugoScp;
%     case 9,
%         load HugoCorticalTable;
%         table = table;
%     case 10,
%         load orenSpinalTable;
%         %         table = spinaltable;
% 
% end;


lnames = cell(length(table),1);
for i=1:length(table),
    lnames(i) = {table(i).fnm};
    curnm = char(table(i).fnm);
    pos = min(findstr(curnm,'e'))-1;
    sess(i,1) = str2num(curnm(2:pos-2));
    sess(i,2) = str2num(curnm(pos-1:pos));
    spid = [];
    for j=1:length(table(i).sp),
        spid(j) = table(i).sp(j).id;
    end;
    [tmp,indx]=sort(spid);
    table(i).sp = table(i).sp(indx);
end

[tmp,indx] = sortrows(sess);
table = table(indx);
lnames = lnames(indx);