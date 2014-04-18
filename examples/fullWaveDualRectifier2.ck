/*

    LiCK  Library for ChucK.
    Copyright (c) 2007-2014 held jointly by the individual authors.

    This file is part of LiCK.

    LiCK is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    LiCK is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with LiCK.  If not, see <http://www.gnu.org/licenses/>.

*/

class FullRectifier extends Chugen
{
    0.0 => float bias;

    fun float tick(float in)
    {
        if (in > bias)
        {
            return in;
        }
        return bias + (bias - in);
    }
}

class FullWaveDualRectifier extends Effect
{
    FullRectifier rect0;
    FullRectifier rect1;

    inlet => rect0 => rect1 => wet;
}

class BiasModule extends Module2
{
    FullWaveDualRectifier @ rect;

    fun float tick(float in, float cv0, float cv1)
    {
        cv0 => rect.rect0.bias;
        cv1 => rect.rect1.bias;
        return in;
    }
}

SinOsc lfo0;
SinOsc lfo1;

0.1 => lfo0.freq;
0.4 => lfo0.gain;
12.0 => lfo1.freq;

TriOsc vco;
110.0 => vco.freq;

BiasModule bias;
FullWaveDualRectifier rect;
0.66 => rect.mix;

lfo0 => bias._cv0;
lfo1 => bias._cv1;
rect @=> bias.rect;

vco => bias => rect => dac;

1::minute => now;
<<<"done">>>;