import { Pill } from '../base/Pill.js';
import { IconAndLabel } from '../base/IconAndLabel.js';

const keyboardLayout = Variable("US", {
  poll: [2000, 'bash -c "y=$(setxkbmap -query | grep layout | awk \'{print $2}\'); echo ${y^^}"'],
});

export const Keyboard = () => Pill([
  IconAndLabel('󰌌', keyboardLayout.bind(), 'keyboard-widget'),
]);