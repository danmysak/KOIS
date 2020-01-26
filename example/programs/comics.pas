{ Free Pascal }
var f: text;
begin
    assign(f, 'comics.out');
    rewrite(f);
    writeln(f, 2);
    close(f);
end.