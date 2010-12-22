function splist = get_sp_list( table, indx)

L = length(table(indx).sp);
splist = cell(L,1);
for i=1:L,
    splist(i) = {num2str(table(indx).sp(i).id)};
end

