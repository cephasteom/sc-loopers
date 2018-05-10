// FM synth with midi 
// Synths should not contain any scaling of input values, this should happen at the midi level.

SynthDef(\fmPoly, {
	arg out = 0, freq = 440, amp = 0.5, carrRatio = 1, modRatio = 2, modMul = 1, gate = 0,
	a = 0.1, d = 0.3, s = 0.5, r = 1,
	aMod = 0.1, dMod = 0.3, sMod = 0.5, rMod = 1;
	var modFreq = (freq * modRatio) / carrRatio, ampEnv, modDepthEnv, carrSig, modSig, sig;
	ampEnv = EnvGen.kr(Env.adsr(a, d, s, r), gate, doneAction: 2) * amp;
	modDepthEnv = EnvGen.kr(Env.adsr(aMod, dMod, sMod, rMod), gate, doneAction: 0) * modMul * amp;
	modSig = SinOsc.ar(modFreq, 0, modDepthEnv * modFreq);
	carrSig = SinOsc.ar(freq + modSig, 0, ampEnv)!2;
	Out.ar(out, carrSig);
}).add;
