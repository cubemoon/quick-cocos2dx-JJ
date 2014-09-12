--
-- Created by IntelliJ IDEA.
-- User: fanqt
-- Date: 2014/4/21
-- Time: 19:39
-- To change this template use File | Settings | File Templates.
--
return

{
    --date
    ["2014-04-20"] = {
        [JJAnalyticsDefine.KEY_USER_BEHAVIORS] = {},
        [JJAnalyticsDefine.KEY_USER_OPERATER] = {},
        [JJAnalyticsDefine.KEY_SINGLE_LORD] = {},
    },
    ["2014-04-21"] = {
        [JJAnalyticsDefine.KEY_USER_BEHAVIORS] = {
            ["date"] = "2014-04-21",
            [JJAnalyticsDefine.KEY_USER_BEHAVIORS] = {
                {
                    ["local_ip"] = "115.182.2.7",
                    ["net_type"] = "WIFI",
                    ["net_carrier"] = "unknow",
                    ["conn"] = {
                        {
                            ["broken"] = 0,
                            ["total_time"] = 392,
                            ["total"] = 1,
                            ["serv_ip"] = "http",
                            ["fail_time"] = 0,
                            ["fail"] = 0,
                            ["up_flow"] = 0,
                            ["down_flow"] = 0,
                            ["online_dur"] = 0
                        },
                        {
                            ["broken"] = 2,
                            ["total_time"] = 392,
                            ["total"] = 2,
                            ["serv_ip"] = "115.182.2.47",
                            ["fail_time"] = 0,
                            ["fail"] = 0,
                            ["up_flow"] = 5989,
                            ["down_flow"] = 55356,
                            ["online_dur"] = 17016
                        },
                    }
                },
                {
                    ["local_ip"] = "118.186.69.35",
                    ["net_type"] = "WIFI",
                    ["net_carrier"] = "unknow",
                    ["conn"] = {
                        {
                            ["broken"] = 0,
                            ["total_time"] = 392,
                            ["total"] = 1,
                            ["serv_ip"] = "http",
                            ["fail_time"] = 0,
                            ["fail"] = 0,
                            ["up_flow"] = 0,
                            ["down_flow"] = 0,
                            ["online_dur"] = 0
                        },
                        {
                            ["broken"] = 2,
                            ["total_time"] = 392,
                            ["total"] = 2,
                            ["serv_ip"] = "115.182.2.47",
                            ["fail_time"] = 0,
                            ["fail"] = 0,
                            ["up_flow"] = 5989,
                            ["down_flow"] = 55356,
                            ["online_dur"] = 17016
                        },
                    }
                }
            }
        },
        [JJAnalyticsDefine.KEY_USER_OPERATER] = {
            ["date"] = "2014-04-21",
            [JJAnalyticsDefine.KEY_USER_OPERATER] = {
                {
                    [JJAnalyticsDefine.KEY_OPERATER] = JJAnalyticsDefine.KEY_CLICK_NEW_GUIDE,
                    [JJAnalyticsDefine.KEY_LOCAL_IP] = "115.182.2.7",
                    [JJAnalyticsDefine.KEY_TOTAL_COUNT] = 5,
                },
                {
                    [JJAnalyticsDefine.KEY_OPERATER] = JJAnalyticsDefine.KEY_CLICK_LOBBY_LOTTERY,
                    [JJAnalyticsDefine.KEY_LOCAL_IP] = "118.186.69.35",
                    [JJAnalyticsDefine.KEY_TOTAL_COUNT] = 10,
                },
            }
        },
        [JJAnalyticsDefine.KEY_SINGLE_LORD] = {},
    },
}

