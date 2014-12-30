Edison
======
The script takes you through steps usefull after flashing your Edison :

1. Fix the boot partition size
  Fix found here : https://communities.intel.com/message/259295

2. Configure wifi
  Just running configure_edison --setup

3. Config opkg and get some packages
  You can update here the packages you want to use

4. Enable GPIO 18 & 19 for I²C
  https://communities.intel.com/docs/DOC-23161 at §11.6 "Configure IO18/IO19 for I 2 C connectivity". Note :
    IO 18 = SDA = pin A4 = pin SDA on Arduino Board
    IO 19 = SCL = pin A5 = pin SDL on Arduino Board

5. Download and custom i2c-tools
  The forked version uses some advices found on this thread about Galileo : https://communities.intel.com/message/241636

6. Proposition of workaround to fix bus i2c-6
  https://richardstechnotes.wordpress.com/2014/11/05/using-i2cdetect-on-the-intel-edison-and-getting-i2c6-to-work-on-the-mini-breakout-board/
