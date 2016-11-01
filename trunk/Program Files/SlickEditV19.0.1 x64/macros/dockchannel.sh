////////////////////////////////////////////////////////////////////////////////////
// $Revision: 54330 $
////////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 SlickEdit Inc. 
// You may modify, copy, and distribute the Slick-C Code (modified or unmodified) 
// only if all of the following conditions are met: 
//   (1) You do not include the Slick-C Code in any product or application 
//       designed to run independently of SlickEdit software programs; 
//   (2) You do not use the SlickEdit name, logos or other SlickEdit 
//       trademarks to market Your application; 
//   (3) You provide a copy of this license with the Slick-C Code; and 
//   (4) You agree to indemnify, hold harmless and defend SlickEdit from and 
//       against any loss, damage, claims or lawsuits, including attorney's fees, 
//       that arise or result from the use or distribution of Your application.
////////////////////////////////////////////////////////////////////////////////////
#ifndef DOCKCHANNEL_SH
#define DOCKCHANNEL_SH

// Timer interval for checking whether to take action when mouse
// is over an image. This is how often to check if we have gone
// past value stored in def_dock_channel_delay.
#define DOCKCHANNEL_TIMER_INTERVAL 100

// Default millisecond delay to wait before hovered dock-channel Tab raises auto-hide window
#define DOCKCHANNEL_HOVER_DELAY 500

enum_flags DockChannelOptions {
/**
 * Mousing over a dock channel item does not activate it.
 * This option forces user to click on a dock channel item
 * to activate it.
 */

   DOCKCHANNEL_OPT_NO_MOUSEOVER  = 0x1
};

struct DockChannelTab {
   int wid;
   _str uid;
   _str caption;
};
struct DockChannelInfo {
   int mdi_wid;
   DockAreaPos area;
   DockChannelTab tabs[];
};

extern void dc_get_info(int mdi_wid, int area, DockChannelInfo& info);
extern void dc_clear(int mdi_wid, DockAreaPos area);

#endif
