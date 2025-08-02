import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { execAsync } from "ags/process"
import { createPoll } from "ags/time"

import Pill from "./Pill";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 1000, "date")
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      layer={Astal.Layer.TOP}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="start">
          <Pill>
            <label
              label={gdkmonitor.get_geometry().width + "x" + gdkmonitor.get_geometry().height}
            />
          </Pill>
        </box>
        <box $type="center" />
        <box $type="end"
        />
      </centerbox>
    </window>
  )
}
