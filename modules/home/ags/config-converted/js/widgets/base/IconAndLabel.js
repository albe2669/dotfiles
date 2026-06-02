import { Icon } from './Icon.js';

export const IconAndLabel = (icon, value, className = '') => Widget.Box({
  className: `sys-widget ${className}`,
  children: [
    Icon(icon, 'il-icon'),
    Widget.Label({
      className: 'il-label',
      label: value,
    }),
  ],
});