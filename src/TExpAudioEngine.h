/*

Copyright (C) Grame 2002-2013

This library is free software; you can redistribute it and modify it under 
the terms of the GNU Library General Public License as published by the 
Free Software Foundation version 2 of the License, or any later version.

This library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License 
for more details.

You should have received a copy of the GNU Library General Public License
along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

Grame Research Laboratory, 9, rue du Garet 69001 Lyon - France
research@grame.fr

*/

#ifndef __TExpAudioEngine__
#define __TExpAudioEngine__

#include <stdint.h>
#include "TAudioRenderer.h"
#include "TExpAudioMixer.h"

//-----------------------
// Class TExpAudioEngine
//-----------------------
/*!
\brief An Audio Engine that can play an arbitrary number au audio expression.
*/

class TExpAudioEngine
{

    protected:

        TExpAudioMixerPtr fMixer;       // Writer of Audio output
        TAudioRendererPtr fRenderer;    // Renderer

    public:

        TExpAudioEngine(TAudioRendererPtr renderer)
        {
            fMixer = new TExpAudioMixer();
            fRenderer = renderer;
            fRenderer->AddClient(fMixer);
        }

        virtual ~TExpAudioEngine()
        {
			fRenderer->RemoveClient(fMixer);
            delete fMixer;
        }

        virtual long Open(long inChan, long outChan, long bufferSize, long sampleRate);
        virtual long Close();

        virtual long Start()
        {
            return fRenderer->Start();
        }
        virtual long Stop()
        {
            return fRenderer->Stop();
        }

};

typedef TExpAudioEngine * TExpAudioEnginePtr;

#endif



