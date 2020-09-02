function string = strmerge(tokens)

ntokens = length(tokens);

string = char(tokens(1));

for i=2:ntokens
    string = [string,char(tokens(i))];
end