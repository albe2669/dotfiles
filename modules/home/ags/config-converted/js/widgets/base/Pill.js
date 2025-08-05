export const Pill = (children, className = '') => Widget.Box({
  className: `pill ${className}`,
  children,
});