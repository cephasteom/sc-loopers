(
	{|in=0, out=0|

	    var synth, win, buttons, firstTime=true, startTime=0, loopTime, isMute=false, buffer, task,
	    cols=2, rows=2, size=80;
	    
	    // GUI window
	    win = Window(\looper, Rect(0, 0, 165, 165), false);

	    // create buttons
	    buttons = 0!(cols*rows);
	    buttons = buttons
	    	.collect({|item, i| Button(win, Rect((i % cols) * size  + 5, trunc(i/cols) * size + 5, size-5, size-5))});

	    // rec button
		buttons[0]
			.states_([
				["O", Color.grey(0.2), Color.new(136/255, 80/255, 83/255)],
				["O", Color.grey(0.2), Color.new(254/255, 95/255, 85/255)],
		    ])
			.action_({ |bu|
				if(bu.value == 0, {
			        if(firstTime) {
			            loopTime = thisThread.clock.beats - startTime; 
			            if (loopTime > 20, {loopTime = 19.9}); // max loop time exceeded
			            task = Task({{ synth.set(\t_reset, 1); loopTime.wait}.loop }).start;
			            firstTime = false;
			        };
			        synth.set(\record, 0);
		        });
				if(bu.value == 1, {
		            if(firstTime) { 
		            	startTime = thisThread.clock.beats;
			            buffer = Buffer.alloc(s, 20 * s.sampleRate, 1);
			            synth = Synth.new(\looper, [\bufnum, buffer.bufnum, \in, in, \out, out]);
		            };
		            synth.set(\record, 1);
		        });
			});

		// erase button
		buttons[1]
			.states_([
		        ["x", Color.grey(0.2), Color.new(198/255, 236/255, 174/255)],
		    ])
		    .action_({ arg bu;
		    	synth.free;
		    	// buffer.free;
		    	task.stop;
		    	firstTime = true;
				buttons[0].value = 0;
		        buttons[2].value = 0;
		        buttons[3].value = 0;
		    });

	    // play/pause button
		buttons[2]
			.states_([
		        ["||", Color.grey(0.2), Color.new(148/255, 201/255, 169/255)],
		        [">", Color.grey(0.2), Color.new(148/255, 201/255, 169/255, 0.5)],
		    ])
		    .action_({ |bu| if(bu.value == 0, { 
			    	task = Task({{ synth.set(\t_reset, 1); loopTime.wait}.loop }).start;
			    	synth.set(\vol, 1);
			    }, { 
			    	task.stop;
			    	synth.set(\vol, 0);
			    }); 
		    });

	    // oct button
		buttons[3]
			.states_([
		        ["-", Color.grey(0.2), Color.new(119/255, 125/255, 167/255)],
		        ["+", Color.grey(0.2), Color.new(119/255, 125/255, 167/255, 0.5)],
		    ])
		    .action_({ |bu| if(bu.value == 0, { 
		    		task.stop;
		    		loopTime = loopTime/2;
		    		synth.set(\rate, 1);
			    	task = Task({{ synth.set(\t_reset, 1); loopTime.wait}.loop }).start;
			    }, { 
			    	task.stop;
			    	loopTime = loopTime*2;
		    		synth.set(\rate, 0.5);
			    	task = Task({{ synth.set(\t_reset, 1); loopTime.wait}.loop }).start;
			    }); 
		    });

	    win.onClose_({synth.free; buffer.free; task.stop}).front;
	}
)
