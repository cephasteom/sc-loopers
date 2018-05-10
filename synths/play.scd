(
	SynthDef(\play, { arg out=0,bufnum=0;
		var playbuf;
		playbuf = PlayBuf.ar(1,bufnum);
		FreeSelfWhenDone.kr(playbuf); // frees the synth when the PlayBuf is finished
		Out.ar(out, playbuf);
	}).add;
)