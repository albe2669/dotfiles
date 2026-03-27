import { Pill } from '../base/Pill.js';
import { IconAndLabel } from '../base/IconAndLabel.js';

const time = Variable("00:00", {
  poll: [1000, 'date "+%H:%M"'],
});

export const Clock = () => Pill([
  IconAndLabel('', time.bind(), 'clock-widget'),
]);