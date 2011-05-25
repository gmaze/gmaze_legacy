% simplify_unit Simplify unit expression
%
% U = simplify_unit(U,[VERB])
% 
% Simplify unit expression U.
% U is a string with products and ratios of units 
% such like: 'm^2/s'
% Option VERB set to 1/true will print some infomations on
% screen.
% 
% Remarks:
%	Powers can be handled if between (.)
% 	Blank spaces are considered as products 'a b' = 'a*b'
% 	Anything between '*' and '/' is considered as a unit.
% 	The function is case sensitive.
%
% Example:
%	simplify_unit('m^2/s*s') % will return: 'm^2'
%	simplify_unit('m^2/s*m^(3/2)') % will return: 'm^(7/2)/s'
%	simplify_unit('1/10^4 1/10^6 mol/kg kg/m^3 m ') % will return: '1/10^10/m^2*mol'
%
% Be careful with LaTeX notations:
%	simplify_unit('\mu mol/kg * kg')
% will return: '\mu*mol'
% while
%	simplify_unit('\mumol/kg * kg')
% will return: '\mumol' as expected
% However, 
%	simplify_unit('^oC/kg * kg')
%	simplify_unit('m^{-3}/kg * kg')
% will return errors. Reformat your string or use (.) for numerical powers
%
% Created: 2010-11-17
% Copyright (c) 2010, Guillaume Maze (Laboratoire de Physique des Oceans).
% All rights reserved.

% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 	* Redistributions of source code must retain the above copyright notice, this list of 
% 	conditions and the following disclaimer.
% 	* Redistributions in binary form must reproduce the above copyright notice, this list 
% 	of conditions and the following disclaimer in the documentation and/or other materials 
% 	provided with the distribution.
% 	* Neither the name of the Laboratoire de Physique des Oceans nor the names of its contributors may be used 
%	to endorse or promote products derived from this software without specific prior 
%	written permission.
%
% THIS SOFTWARE IS PROVIDED BY Guillaume Maze ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Guillaume Maze BE LIABLE FOR ANY 
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
% BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
% STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%



function expr = simplify_unit(U,varargin)

verb = false;
switch nargin - 1
	case 0
		% No options
	case 1
		verb = varargin{1};
	otherwise
		error('Bad number of arguments');
end

if verb,disp(sprintf('You entered:\n\t%s',U));end

%- Clean up the expression:
U = dblk1(U);
U = strrep(U,'    ',' ');
U = strrep(U,'   ',' ');
U = strrep(U,'  ',' ');
%disp(sprintf('I understand:\n\t%s',U))

U = strrep(U,'/ ','/');
U = strrep(U,' /','/');
U = strrep(U,'* ','*');
U = strrep(U,' *','*');
U = strrep(U,' ','*');
U = fixLaTeX(U);

if verb,disp(sprintf('I understand:\n\t%s',U));end

%- Split terms:
[tlist oplist] = split(U);

%- Reconstruct numerator and denominator:
up = tlist{1};
dw = '';
for it = 2 : length(tlist)
	switch oplist(it-1)
		case '*'
			up = sprintf('%s*%s',up,tlist{it});
		case '/'
			dw = sprintf('%s*%s',dw,tlist{it});
	end
end%for it
if length(dw>2),dw=dw(2:end);end % Because we started with dw='';
% Clean a little bit, things like: 1*1
up=clean(up);
dw=clean(dw);

if verb,
	%disp(sprintf('Numerator   is: %s',up))
	%disp(sprintf('Denominator is: %s',dw));
	disp(sprintf('Numerator   is: %s',strrep(up,'*',' x ')));
	disp(sprintf('Denominator is: %s',strrep(dw,'*',' x ')));
end

%- Identify unique unit in both expressions
uplist = split(up);
for it = 1 : length(uplist)
	if 0
		term = uplist{it};
		a = strread(term,'%s','delimiter','^');
		uplist(it) = a(1);
	else % Try to handle LaTeX notation:		
		% We don't want to assimilate the upperscript from the power:
		% \rho^{t} is not \rho^2
		% We assume the term is of the form: X^{t}^{i}
		% where X^{t} is the unit and i the power		
		term = uplist{it};
		a = strread(term,'%s','delimiter','^');
		if length(a) > 1
			ak = zeros(1,length(a)-1);
			for ia = 2 : length(a)
				s = strrep(strrep(a{ia},'{',''),'}','');
				if isempty(str2num(s))
					ak(ia-1) = 1;					
				end		
			end%for ia
			% Reconstruct unit:
			s = a{1};
			for ii = 1 : length(ak)
				if ak(ii)
					s = sprintf('%s^%s',s,a{ii+1});
				end
			end
			uplist(it) = {s};				
		else
			uplist(it) = a(1);
		end
		
	end
end%for itup
dwlist = split(dw);
for it = 1 : length(dwlist)
	term = dwlist{it};
	a = strread(term,'%s','delimiter','^');
	dwlist(it) = a(1);
end%for itup
unitlist = unique(union(unique(dwlist),unique(uplist)));
unitlist = sort(unitlist);
if verb,disp('Unique units are:');unitlist',end



%- Loop over unique units and identify their final powers:
unitpower = zeros(1,length(unitlist));
uplist = split(up);
dwlist = split(dw);
%-- Scan numerator:
for it = 1 : length(uplist)
	term = uplist{it};
	if 0
		a    = strread(term,'%s','delimiter','^');
		thisunit = a(1);
		if length(a)>1
			thispower = a{2};
			thispower = strrep(strrep(thispower,'(',''),')','');			
		else
			thispower = '1';
		end
		[ii ia] = intersect(unitlist,thisunit);
		try 
			x = eval(thispower);
			unitpower(ia) = unitpower(ia) + x;
		catch
			error(sprintf('Please avoid notations like ''^%s'', I don''t know how to do that !',thispower));
		end
	else % Try to handle LaTeX notation:
			
		a = strread(term,'%s','delimiter','^');
		if length(a) > 1			
			thisunit = a{1};
			x = 0;
			for ia = 2 : length(a)
				p = strrep(strrep(a{ia},'(',''),')','');
				if ~isempty(str2num(p))
					x = x + eval(p);
				else
					thisunit = sprintf('%s^%s',thisunit,a{ia});
				end
			end
			thisunit = {thisunit};
			if isempty(intersect(unitlist,thisunit))
				error('Something went wrong when handling LaTeX notation ...');
			else
				[ii ia] = intersect(unitlist,thisunit);				
			end
		else		
			thisunit = a(1);
			thispower = '1';
			x = eval(thispower);
			[ii ia] = intersect(unitlist,thisunit);
		end		
		unitpower(ia) = unitpower(ia) + x;
		
	end
end%for it
%-- Scan denominator:
for it = 1 : length(dwlist)
	term = dwlist{it};
	
	if 0
		
		a    = strread(term,'%s','delimiter','^');
		thisunit = a(1);
		if length(a)>1
			thispower = a{2};
			thispower = strrep(strrep(thispower,'(',''),')','');			
		else
			thispower = '1';
		end
		[ii ia] = intersect(unitlist,thisunit);
	%	unitpower(ia) = unitpower(ia) - eval(thispower);
		try 
			x = eval(thispower);
			unitpower(ia) = unitpower(ia) - x;
		catch
			error(sprintf('Please avoid notations like ''^%s'', I don''t know how to do that !',thispower));
		end
	
	else % Try to handle LaTeX notation:
			
		a = strread(term,'%s','delimiter','^');
		if length(a) > 1			
			thisunit = a{1};
			x = 0;
			for ia = 2 : length(a)
				p = strrep(strrep(a{ia},'(',''),')','');
				if ~isempty(str2num(p))
					x = x + eval(p);
				else
					thisunit = sprintf('%s^%s',thisunit,a{ia});
				end
			end
			thisunit = {thisunit};
			if isempty(intersect(unitlist,thisunit))
				error('Something went wrong when handling LaTeX notation ...');
			else
				[ii ia] = intersect(unitlist,thisunit);
			end
		else		
			thisunit = a(1);
			thispower = '1';
			x = eval(thispower);
			[ii ia] = intersect(unitlist,thisunit);
		end		
		unitpower(ia) = unitpower(ia) - x;
	end
end%for it		

%- Now create the simplified unit:
expr = '1';
if verb,unitpower,end
for iu = 1 : length(unitlist)
	if     unitpower(iu) > 0		
		expr = sprintf('%s*%s',expr,form(unitlist{iu},unitpower(iu)));
	elseif unitpower(iu) < 0
		expr = sprintf('%s/%s',expr,form(unitlist{iu},abs(unitpower(iu))));
	elseif unitpower(iu) == 0
	end
end
expr = clean(expr);

end %function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transform
%	\rho^{ne}^{3}
% into
%	\rho^{ne}^(3)
%
function str = fixLaTeX(str);
	
	done = false;
	ic = 0;
	while done ~= true
		ic = ic + 1;
		if ic <= length(str)
			if str(ic) == '^'
				if str(ic+1) == '{'
					ii = [ic+1 ic+min(strfind(str(ic+1:end),'}'))];
					argu = str(ii(1)+1:ii(2)-1);
					if ~isempty(str2num(argu))
						str(ii(1)) = '(';
						str(ii(2)) = ')';
					end
				else
					ii = [ic+1 ic+min([strfind(str(ic+1:end),'+') strfind(str(ic+1:end),'-') strfind(str(ic+1:end),'/') strfind(str(ic+1:end),'*') strfind(str(ic+1:end),'^')])];
					argu = str(ii(1)+1:ii(2)-1);
					if isempty(argu)
						argu = str(ii(1));
						if ~isempty(str2num(argu))
							
						end
					else
						if ~isempty(str2num(argu))
							str(ii(1)) = '(';
							str(ii(2)) = ')';
						end
					end
				end
			end
		else
			return
		end
	end%while
	
end%fucntion

function str = fixLaTeX_0(str);

	a = strread(str,'%s','delimiter','^');
	if length(a) == 1
		str = a{1};
		return;
	end
	
	str = a{1};
	a   = a(2:end);
	isn = zeros(1,length(a));
	for ia = 1 : length(a)
		s = strrep(strrep(a{ia},'(',''),')','');
		s = strrep(strrep(s    ,'{',''),'}','');
		switch isempty(str2num(s))
			case 0 % upperscript is numeric
				isn(ia) = 1;
			case 1 % upperscript is character
		end
	end%for ia
	ii = 1 : length(a);
	ii = [ii(~isn) ii(isn==1)];
	a  = a(ii);
	
	for ia = 1 : length(a)
		s = strrep(strrep(a{ia},'(',''),')','');
		s = strrep(strrep(s    ,'{',''),'}','');
		switch isempty(str2num(s))
			case 0 % upperscript is numeric
				s = strrep(strrep(a{ia},'{','('),'}',')');
				str = sprintf('%s^%s',str,s);
			case 1 % upperscript is character
				str = sprintf('%s^%s',str,a{ia});
		end
	end%for ia
	
end%function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = form(unit,power)
	
	if power == 1
		str = unit;
		return
	end
	
	if power == -1
		str = sprintf('%s^(-1)',unit);
		return
	end
	
	if power == fix(power)
		if power > 0
			str = sprintf('%s^%i',unit,int8(power));
		else
			str = sprintf('%s^(-%i)',unit,int8(abs(power)));
		end
		return
	end
	
	if power ~= fix(power)
		% power should be a rational number		
		expr = rats(power);
		expr = strrep(expr,' ','');
		str = sprintf('%s^(%s)',unit,expr);
		return
	end
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function str = clean(str)
	str = strrep(str,'*1*','*');
	if length(str)>2
		if strcmp(str(1:2),'1*')
			str = str(3:end);
		end
	end
	
	if length(str)>2
		if strcmp(str(end-1:end),'*1')
			str = str(1:end-2);
		end
	end
	
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% split an expression with / and *
function [tlist oplist] = split(U);
	
	Ut = U;
	Ut = strrep(strrep(Ut,'*','&'),'/','&');
	
	% Test to see if & are in between (.)
	op = strfind(Ut,'(');
	cl = strfind(Ut,')');
	if length(op)>=1
		for ipair = 1 : length(op)
			pt = strfind(Ut,'&');
			Ut(intersect([op(ipair):cl(ipair)],pt)) = U(intersect([op(ipair):cl(ipair)],pt));
		end%for ipair
	end
	
	% Identify terms:
	tlist = strread(Ut,'%s','delimiter','&');

	iop = 0;
	for ii = 1 : length(Ut)
		if strcmp(Ut(ii),'&')
			iop = iop + 1;
			oplist(iop) = U(ii);
		end
	end
	if ~exist('oplist','var')
		oplist = '';
	end
	
	if length(oplist) ~= length(tlist)-1
		error('Can''t simplify this unit because I can''t split operators and parameters');
	end
	
end%function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remove empty space at the beginning of the string:
function t = dblk1(t)
	done = 0;
	while done ~= 1
		if isspace(t(1))
			t = t(2:end);
		else
			done = 1;
		end
	end%while
	done = 0;
	while done ~= 1
		if isspace(t(end))
			t = t(1:end-1);
		else
			done = 1;
		end
	end%while
end


