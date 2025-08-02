type Props = {
  children?: JSX.Element | Array<JSX.Element>
}


export default function Pill({ children }: Props) {
  return (
    <box class={`pill`}>
      {children}
    </box>
  )
}
