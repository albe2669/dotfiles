import { Clock } from '../clock/Clock.js';
import { Tray } from '../tray/Tray.js';
import { System } from '../system/System.js';
import { Keyboard } from '../keyboard/Keyboard.js';

const Left = () => Widget.Box({
  children: [
    Clock(),
    Tray(),
  ],
});

const Right = () => Widget.Box({
  hpack: 'end',
  children: [
    Keyboard(),
    System(),
  ],
});

export const Bar = (monitor = 0) => Widget.Window({
  name: `bar-${monitor}`,
  monitor,
  anchor: ['top', 'left', 'right'],
  exclusivity: 'exclusive',
  layer: 'top',
  child: Widget.CenterBox({
    className: 'main',
    startWidget: Left(),
    endWidget: Right(),
  }),
});