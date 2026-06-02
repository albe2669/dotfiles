import { Pill } from '../base/Pill.js';

export const Tray = () => Pill([
  Widget.SystemTray({
    items: SystemTray.bind('items').as(items => 
      items.map(item => Widget.Button({
        child: Widget.Icon({ 
          icon: item.icon,
          size: 18,
        }),
        onPrimaryClick: (_, event) => item.activate(event),
        onSecondaryClick: (_, event) => item.openMenu(event),
        tooltip_markup: item.bind('tooltip_markup'),
      }))
    ),
  }),
]);