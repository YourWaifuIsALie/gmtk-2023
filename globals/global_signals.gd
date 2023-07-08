## Loaded via autoload for global signal access 
extends Node

signal button_options()
signal button_play()

signal transition_start()
signal transition_wait()
signal transition_finish()

signal event_begin(event_name: String)

## Attempt to emit a signal given a name and optional value
## Mainly here for buttons
func emit(signal_name: String, value: Variant = null) -> bool:
	if value:
		if self.emit_signal(signal_name, value) == ERR_UNAVAILABLE:
			return false
	else:
		if self.emit_signal(signal_name) == ERR_UNAVAILABLE:
			return false
	return true
