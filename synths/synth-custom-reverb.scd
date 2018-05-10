SynthDef.new(\customReverb, {
	arg in, out=0, amp=1, mix=0.2, 
	preDelay=0.1, revTime=2, dampHz=4500, density=16;
	var dry, wet, temp, sig;
	dry = In.ar(in, 2);
	temp = In.ar(in, 2);
	wet = 0;
	temp = DelayN.ar(temp, 0.2, preDelay); // predelay - how long before you hear reflections
	temp = density.do{
		temp = AllpassN.ar(temp, 0.2, {Rand(0.001, 0.05)}!2, revTime);
		temp = LPF.ar(temp, dampHz);
		wet = wet + temp;
	};
	sig = XFade2.ar(dry, wet, mix*2-1, amp);
	Out.ar(out, sig);
}).add;

// // Example
// ~reverbBus = Bus.audio(s);
// ~reverbBus.free;

// ~rev = Synth.new(\customReverb, [\in, ~reverbBus]);
// ~rev.set(\mix, 1, \revTime, 4, \dampHz, 500, \amp, 1.3);
// ~rev.free;

// "/Users/Pete/Documents/my-coding/supercollider/synths/synth-sine.scd".load;

// p = Pbind(
// 	\instrument, \sine,
// 	\dur, Pexprand(0.01, 1, inf),
// 	\freq, Pshuf( (Scale.lydian.degrees+60).midicps, inf ) * Prand([0.5, 1, 2, 4], inf),
// 	\out, ~reverbBus,
// 	\atck, Pwhite(0.001, 0.01, inf),
// 	\rel, Pwhite(0.2, 0.5, inf),
// 	\amp, 0.3,
// ).play;

// p.stop;