import { Pill } from '../base/Pill.js';
import { IconAndLabel } from '../base/IconAndLabel.js';

const Separator = () => Widget.Box({
  className: 'separator',
  child: Widget.Label({
    label: '|',
  }),
});

const cpu = Variable('0', {
  poll: [2000, 'bash -c "top -bn1 | grep Cpu | awk \'{print $2}\' | cut -d\'%\' -f1"'],
});

const ram = Variable('0', {
  poll: [2000, 'bash -c "free | grep Mem | awk \'{printf \"%.0f\", $3/$2 * 100.0}\'"'],
});

const disk = Variable('0', {
  poll: [10000, 'bash -c "df / | tail -1 | awk \'{print $5}\' | sed \'s/%//\'"'],
});

const Cpu = () => IconAndLabel('', cpu.bind().as(c => `${Math.round(parseFloat(c) || 0)}%`), 'cpu-widget');

const Ram = () => IconAndLabel('', ram.bind().as(r => `${r}%`), 'ram-widget');

const Disk = () => IconAndLabel('󰋊', disk.bind().as(d => `${d}%`), 'disk-widget');

const batteryChargingIcons = [
  '󰁺', '󰁻', '󰁼', '󰁽', '󰁾',
  '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'
];

const batteryChargingIndex = Variable(0, {
  poll: [750, () => Math.floor(Date.now() / 750) % 10],
});

const Temp = () => {
  const temp = Variable(0, {
    poll: [2000, 'bash -c "sensors | grep Package | awk \'{print $4}\' | sed \'s/+//;s/°C//\'"', (out) => parseInt(out) || 0],
  });

  return IconAndLabel(
    temp.bind().as(t => {
      if (t >= 80) return '';
      if (t >= 70) return '';
      if (t >= 60) return '';
      if (t >= 50) return '';
      return '';
    }),
    temp.bind().as(t => `${t}°C`),
    temp.bind().as(t => {
      if (t > 80) return 'temp-widget temp-widget-crit';
      if (t > 60) return 'temp-widget temp-widget-warn';
      return 'temp-widget temp-widget-norm';
    })
  );
};

const Battery = () => {
  const battery = Utils.merge([
    Utils.timeout(1000, () => {
      try {
        const capacity = Utils.exec('cat /sys/class/power_supply/BAT0/capacity');
        const status = Utils.exec('cat /sys/class/power_supply/BAT0/status');
        return { capacity: parseInt(capacity), status };
      } catch (e) {
        return null;
      }
    })
  ], () => ({}));

  if (!battery) return Widget.Box();

  return IconAndLabel(
    battery.bind().as(b => {
      if (!b || !b.capacity) return '';
      if (b.status === 'Charging') {
        return batteryChargingIcons[batteryChargingIndex.value];
      }
      return batteryChargingIcons[Math.min(Math.floor(b.capacity / 10), 9)];
    }),
    battery.bind().as(b => b && b.capacity ? `${b.capacity}%` : '0%'),
    battery.bind().as(b => {
      if (!b) return 'battery-widget battery-widget-norm';
      if (b.status === 'Charging') return 'battery-widget battery-widget-charging';
      if (b.capacity <= 15) return 'battery-widget battery-widget-crit';
      return 'battery-widget battery-widget-norm';
    })
  );
};

const hasBattery = Variable(false, {
  poll: [5000, 'test -f /sys/class/power_supply/BAT0/capacity && echo true || echo false', out => out.trim() === 'true'],
});

export const System = () => Pill([
  Cpu(),
  Separator(),
  Ram(),
  Separator(),
  Disk(),
  Separator(),
  Temp(),
  Widget.Box({
    visible: hasBattery.bind(),
    children: [
      Separator(),
      Battery(),
    ],
  }),
], 'system-widget');