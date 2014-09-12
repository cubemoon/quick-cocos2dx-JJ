package cn.jj.base;

import cn.egame.terminal.egameforonlinegame.EgameFee;
import cn.egame.terminal.egameforonlinegame.EgameFeeResultListener;
import cn.jj.base.JJUtil;

public class EgamePayController {

	private static final String TAG = "EgamePayController";

	private static EgamePayController m_self = null;
	
	private final static int PW_TYPE_WEB_ACCOUNT = 1002; // 外部网站账户
	private final static int PW_TYPE_SMS = 1003; // 短信代收费
	
	private JJActivity m_Activity;

	private EgamePayController(JJActivity a_Activity) {
		m_Activity = a_Activity;
	}

	public static EgamePayController getInstance(JJActivity a_Activity) {
		if (m_self == null) {
			m_self = new EgamePayController(a_Activity);
		}
		return m_self;
	}

	public void doPay(int payType, int amount, String param) {

		switch (payType) {
		case PW_TYPE_WEB_ACCOUNT:
			EgameFee.pay(m_Activity, amount / 100, param, feeResultListener);
			break;
		case PW_TYPE_SMS:
			EgameFee.payBySms(m_Activity, amount / 100, param, false, feeResultListener);
//			if (JJUtil.isCTSim()) {
//				EgameFee.payBySms(m_Activity, amount / 100, param, false, feeResultListener);
//			} else {
//				JJUtil.prompt(m_Activity, "当前无SIM卡或不是电信卡！");
//			}
			break;
		}
	}

	private EgameFeeResultListener feeResultListener = new EgameFeeResultListener() {

		@Override
		public void egameFeeSucceed(String arg0, int arg1, String arg2) {
			JJUtil.prompt(m_Activity, "计费请求发送成功");
		}

		@Override
		public void egameFeeFailed(int arg0) {
			JJUtil.prompt(m_Activity, "计费请求发送失败");
		}

		@Override
		public void egameFeeCancel() {
			JJUtil.prompt(m_Activity, "计费请求已取消");
		}
	};
}
