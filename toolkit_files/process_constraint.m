% this function looks for occurrences of the endogenous variables in
% endo_names in the input string constraint
% all occurrences of the endogenous variables are appended a suffix
% if the invert_switch is true, the direction of the inequality in the
% constraint is inverted

function constraint1 = process_constraint(constraint,suffix,endo_names,invert_switch)

% create a list of delimiters that can separate parameters and endogenoous
% variables in the string that expresses the constraint
delimiters = char(',',';','(',')','+','-','^','*','/',' ','>','<','=');

% split the string that holds the constraint into tokens
tokens = tokenize(constraint,delimiters);

ntokens = length(tokens);

% search for tokens that match the list of endogenous variables
for i=1:ntokens
    if ~isempty(find(strcmp(tokens(i),endo_names)))
        % when there is a match with an endogenous variable append the
        % suffix
        tokens(i) = cellstr([char(tokens(i)),suffix]);
    end
    
    % if the invert_switch is true
    % reverse the direction of the inequality
    if invert_switch
        if  strcmp(tokens(i),cellstr('>'))
            tokens(i) = cellstr('<');
        elseif strcmp(tokens(i),cellstr('<'))
            tokens(i) = cellstr('>');
        end
    end
end

% reassemble the tokens to create a string that expresses the constraint
constraint1 = strmerge(tokens);