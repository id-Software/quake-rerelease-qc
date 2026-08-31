/*  Copyright (C) 1996-2026 id Software LLC

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

///////////////////////////////////////////////////////////
// Math related functions
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
// Modulus

float mod(float v, float m)  
{
    float r;
	
	if(m == 0) objerror("Illegal op: mod(x, 0)!");
	if(fabs(v) < m) return v;
	if(v == m) return 0;
    
	r = floor(v / m) * m;
    
	return v - r;
}

///////////////////////////////////////////////////////////
// Sine

float sin(float angle)
{
    vector a = {0, angle, 0};
    makevectors(a);
    return v_forward_y;
}

///////////////////////////////////////////////////////////
// Cosine

float cos(float angle)
{
    vector a = {0, angle, 0};
    makevectors(a);
    return v_forward_x;
}

/*
================
Bitshift emulation
================
*/

float SUB_LeftShift(float num, float bits)
{
	bits = floor(bits);
	while(bits > 0)
	{
		num*= 2;
		bits--;
	}
	return num;
}

float SUB_RightShift(float num, float bits)
{
	bits = floor(bits);
	while(bits > 0)
	{
		num/= 2;
		bits--;
	}
	return num;
}
