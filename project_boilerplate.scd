s.quit;

// **********************************************************************
// 1. SERVER CONFIG - any server setup key to this piece
// **********************************************************************

// read ServerOptions help file for properties of s.options
s = Server.local;
s.options.outDevice_('Built-in Output');
s.options.numOutputBusChannels_(4); // outs 0 - 3
s.options.inDevice_('Built-in Microph');
s.options.numInputBusChannels_(2); // ins 4-5
s.options.sampleRate_(44100);
s.options.memSize_(2.pow(20)); // roughly 1 gig of realtime memory
s.newBusAllocators;
ServerBoot.removeAll;
ServerTree.removeAll;
ServerQuit.removeAll;

// **********************************************************************
// 2. INIT GLOBAL VARIABLES
// **********************************************************************
~out = 0;
~tapBus1 = 2;
~in1 = 4; 
~in2 = 5; 
TempoClock.default.tempo = 104 / 60;
~projectPath = "/Users/Pete/Documents/my-coding/supercollider/projects/project_loopers";
~synthsPath = ~projectPath++"/synths";
~midiPath = ~projectPath++"/midi";
~guiPath = ~projectPath++"/gui";

// **********************************************************************
// 3. DEFINE PIECE SPECIFIC FUNCTIONS
// **********************************************************************
~makeBuffers = {
	~looper1Buf = Buffer.alloc(s, 44100 * 20, 1); // a 20 second 1 channel Buffer
};
// ~makeBusses = {
// 	~busses = Dictionary.new;
// 	~busses.add(\tapBus1 -> Bus.audio(s, 1));
// };
~makeGui = {
	// MIDIIn.connectAll
	g = Dictionary.new;
	g.add(\looperGui -> (~guiPath++"/looper_gui.scd").load);
	
};
~makeMidi = {
	MIDIIn.connectAll;
	e = Dictionary.new;
	e.add(\controls -> (~midiPath++"/controls.scd").load);
};
~cleanup = {
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

// **********************************************************************
// 4. REGISTER FUNCTIONS WITH ABSTRACT SERVER ACTION
// **********************************************************************
ServerBoot.add(~makeBuffers); 
// ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup); // clean up when quit the server

// **********************************************************************
// 5. BOOT SERVER
// **********************************************************************
s.waitForBoot({
	s.sync;
	// synths
	(~synthsPath++"/tapDelay.scd").load;
	s.sync;
	// nodes
	ServerTree.add(~makeNodes);
	// events/midi/guis
	ServerTree.add(~makeGui); 
	// ServerTree.add(~makeMidi); 
	s.freeAll; s.sync; s.meter;
	"loaded".postln;
});

// **********************************************************************
// 6. PERFORMANCE
// **********************************************************************
// g[\looperGui].value(~looper1Buf, ~out, ~in1, ~in2, ~tapBus1);
