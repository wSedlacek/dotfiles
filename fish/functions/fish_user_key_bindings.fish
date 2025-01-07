function fish_user_key_bindings
  bind -M normal \cd true
  bind -M insert \cd true
  bind -M insert \cf 'thefuck-command-line'
  bind -M insert \cc kill-whole-line repaint
end
