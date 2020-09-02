function [regime regimestart]=map_regimes(violvecbool)

nperiods = length(violvecbool)-1;

% analyse violvec and isolate contiguous periods in the other regime.
            regime(1) = violvecbool(1);
            regimeindx = 1;
            regimestart(1) = 1;
            for i=2:nperiods
                if violvecbool(i)~=regime(regimeindx)
                    regimeindx=regimeindx+1;
                    regime(regimeindx) = violvecbool(i);
                    regimestart(regimeindx)=i;
                end
            end
            
            
            if (regime(1) == 1 & length(regimestart)==1)
                warning('Increase nperiods');
            end
            
            if (regime(end)==1)
                warning('Increase nperiods');
            end
            
