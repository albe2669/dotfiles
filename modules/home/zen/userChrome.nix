{colors}:
with colors; ''
:root {
  --zen-colors-primary: #${base02} !important;
  --zen-primary-color:  #${base0C} !important;
  --zen-colors-secondary: #${base02} !important;
  --zen-colors-tertiary: #${base00} !important;
  --zen-colors-border: #${base0C} !important;
  --zen-themed-toolbar-bg: #${base00} !important;
  --zen-main-browser-background: #${base00} !important;
  
  --toolbar-field-color: #${base0C} !important;
  --toolbar-field-focus-color: #${base06} !important;
  --toolbar-color: #${base0C} !important;
  --toolbar-bgcolor: #${base02} !important;
  
  --toolbarbutton-icon-fill: #${base0C} !important;
  
  
  --arrowpanel-color: #${base06} !important;
  --arrowpanel-background: #${base01} !important;
  
  --tab-selected-textcolor: #${base0A} !important;
  
  --newtab-text-primary-color: #${base06} !important;
  --newtab-background-color: #${base01} !important;
  
  --lwt-text-color: #${base06} !important;
  --lwt-sidebar-text-color: #${base06} !important;
  --lwt-sidebar-background-color: #${base00} !important;
  
  --sidebar-text-color: #${base06} !important;
  
  --toolbox-bgcolor-inactive: #${base00} !important;
  --toolbox-textcolor: #${base05} !important;
  --toolbox-textcolor-inactive: #${base05} !important;
}

#permissions-granted-icon {
  color: #${base00} !important;
}

.sidebar-placesTree {
  background-color: #${base00} !important;
}

#zen-workspaces-button {
  background-color: #${base00} !important;
}

#TabsToolbar {
  background-color: #${base00} !important;
}

#urlbar-background {
  background-color: #${base01} !important;
}

.content-shortcuts {
  background-color: #${base01} !important;
  border-color: #${base0C} !important;
}

.urlbarView-url {
  color: #${base0C} !important;
}

#zenEditBookmarkPanelFaviconContainer {
  background: #${base00} !important;
}

#zen-media-controls-toolbar {
  & #zen-media-progress-bar {
    &::-moz-range-track {
      background: #${base02} !important;
    }
  }
}

toolbar .toolbarbutton-1 {
  &:not([disabled]) {
    &:is([open], [checked])
      > :is(
        .toolbarbutton-icon,
        .toolbarbutton-text,
        .toolbarbutton-badge-stack
      ) {
      fill: #${base00};
    }
  }
}

.identity-color-blue {
  --identity-tab-color: #${base0D} !important;
  --identity-icon-color: #${base0D} !important;
}

.identity-color-turquoise {
  --identity-tab-color: #${base0D} !important;
  --identity-icon-color: #${base0D} !important;
}

.identity-color-green {
  --identity-tab-color: #${base0B} !important;
  --identity-icon-color: #${base0B} !important;
}

.identity-color-yellow {
  --identity-tab-color: #${base0A} !important;
  --identity-icon-color: #${base0A} !important;
}

.identity-color-orange {
  --identity-tab-color: #${base09} !important;
  --identity-icon-color: #${base09} !important;
}

.identity-color-red {
  --identity-tab-color: #${base08} !important;
  --identity-icon-color: #${base08} !important;
}

.identity-color-pink {
  --identity-tab-color: #${base0E} !important;
  --identity-icon-color: #${base0E} !important;
}

.identity-color-purple {
  --identity-tab-color: #c6a0f6 !important; /* Leftover from catpuccin */
  --identity-icon-color: #c6a0f6 !important;
}

hbox#titlebar {
  background-color: #${base00} !important;
}

#zen-appcontent-navbar-container {
  background-color: #${base00} !important;
}
''
