function [dt_S_SP3] = interpolate_SP3_clock(time, SP3, sat)

% SYNTAX:
%   [dt_S_SP3] = interpolate_SP3_clock(time, SP3, sat);
%
% INPUT:
%   time = interpolation timespan (GPS time, continuous since 6-1-1980)
%   SP3   = structure containing precise ephemeris data
%   sat   = satellite PRN
%
% OUTPUT:
%   dt_S_SP3  = interpolated clock correction
%
% DESCRIPTION:
%   SP3 (precise ephemeris) clock correction linear interpolation.

%----------------------------------------------------------------------------------------------
%                           goGPS v0.4.3
%
% Copyright (C) 2009-2014 Mirko Reguzzoni, Eugenio Realini
%----------------------------------------------------------------------------------------------
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%----------------------------------------------------------------------------------------------

if (isempty(SP3.clock_hr))
    SP3_time = SP3.time;
    SP3_clock = SP3.clock(sat,:);
else
    SP3_time = SP3.time_hr;
    SP3_clock = SP3.clock_hr(sat,:);
end

interval = SP3.clock_rate;

%find the SP3 epoch closest to the interpolation time
[~, p] = min(abs(SP3_time - time));

b = SP3_time(p) - time;

%extract the SP3 clocks
if (b>0)
    SP3_c = [SP3_clock(p-1) SP3_clock(p)];
    u = 1 - b/interval;
else
    SP3_c = [SP3_clock(p) SP3_clock(p+1)];
    u = -b/interval;
end

dt_S_SP3  = NaN;

if (sum(SP3_c~=0) == 2 && isempty(find(SP3_c >= 0.999, 1)))

    %linear interpolation (clock)
    dt_S_SP3 = (1-u)*SP3_c(1) + u*SP3_c(2);

    %plot([0 1],SP3_c,'o',u,dt_S_SP3,'.')
    %pause
end
