function ostring = get_include_field( table ,itable, ispike)

if ~isfield( table(itable).sp, 'include'),
    ostring = 'Include = NAN';
else
    if table(itable).sp(ispike).include == 1,
        ostring = 'Include = Yes';
    else
        ostring = 'Include = No';
    end;
    
end
    
    
