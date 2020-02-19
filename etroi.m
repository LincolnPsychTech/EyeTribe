function roi = etroi(name, varargin)

switch length(varargin)
    case 1
        stim = varargin{1};
        if all( isfield(varargin{1}, {'Type', 'Pos', 'Dir', 'Obj'}) ) % If user has supplied an @etstim structure...
            if length(stim.Pos) == 4
                x = stim.Pos(1) + [0 0 stim.Pos(3) stim.Pos(3)];
                y = stim.Pos(2) + [0 stim.Pos(4) stim.Pos(4) 0];
            else
                error("When supplying a stimulus structure in place of coordinates, stimulus must have 4 position values.");
            end
        else
            error("When supplying a stimulus in place of coordinates, that stimulus must be a stimulus structure generated using @etstim");
        end
    case 2
        x = varargin{1};
        y = varargin{2};
    otherwise
        error("Incorrect number of inputs.")
end


if isnumeric(x) % If x is numeric...
    if isnumeric(y) % ...and y is also numeric...
        if length(y) ~= length(x) % ...but x and y are different lengths...
            wrongy(); % Deliver error about incorrect y input
        end
    else % ...but y is not numeric...
        if isa(y,'function_handle') % ...and y is a function handle instead...
            if length(y(x)) == length(x) % ...and supplying x as an input to y's function gives an array of the same size as x...
                y = y(x); % Get y values by applying y's functin to x
            else % ...but supplying x as an input to y's function does not give an array of the same size as x... 
                wrongy(); % Deliver error about incorrect y input
            end
        else % ...and y is not a function handle...
            wrongy(); % Deliver error about incorrect y input
        end
    end
else % If x is not numeric...
    error('x values must be a numeric array'); % Deliver error about incorrect x input
end

switch class(name)
    case 'string' % If name is a string array...
        if length(name) > 1 % ...and it contains more than one string
            error('name cannot be an array multiple strings'); % Error prompting only one string
        else
            name = name{:}; % Convert to character array
        end
    case 'char' % If name is a character array...
        name = reshape(name, 1, []); % Reshape it to all be one row
    otherwise % If name is not a string or character array...
        error('name must be either a string or character'); % Error prompting string or character array input
end

roi = struct(...
    'Class', 'roi', ... % Class, always set to "roi", identified structure as an roi object
    'Name', name, ... % Store name
    'x', x, ... % Store x values
    'y', y ... % Store y values
    );

    

    function wrongy()
        % Function to deliver an error when incorrect y value is supplied
        
        error('y values must be either a numeric array of the same dimensions as x or a function handle whereby y(x) is a numeric array of the same dimensions of x');
    end

end

