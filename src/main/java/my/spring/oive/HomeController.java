package my.spring.oive;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import dao.SearchDAO;
import dao.UserDAO;
import service.UserService;
import vo.UserVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired
	UserDAO dao;

	@Autowired
	SearchDAO SearchDAO;
	
	@Autowired
	UserService service;

	@Autowired
	HttpSession session;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home() {
		ModelAndView mav = new ModelAndView();

		//TODO : 인터셉터 내에서 처리할 수는 없을까?
		if(session.getAttribute("user") != null) 
			mav.setViewName("redirect:/self_introduce/list");
		else mav.setViewName("example");

		return mav;
	}


	@RequestMapping(value = "/", method = RequestMethod.POST)
	public ModelAndView login(String userId, String password, RedirectAttributes redirectAttr) {
		ModelAndView mav = new ModelAndView();

		if(service.login(userId, password)) {
			System.out.println("로그인 성공");
			mav.setViewName("redirect:/self_introduce/list");
		}
		else {
			System.out.println("로그인 실패");
			mav.setViewName("redirect:/");
			redirectAttr.addFlashAttribute("msg", "아이디 또는 비밀번호를 확인해주세요.");
		}
		return mav;
	}

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String register() {
		return "join";
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public ModelAndView register(UserVO vo) {
		ModelAndView mav = new ModelAndView();

		if(service.join(vo)) {
			mav.addObject("msg", "회원가입에 성공했습니다. 로그인 후 서비스를 이용해 주세요.");
			mav.setViewName("example");
		}
		else {
			mav.setViewName("join");
			mav.addObject("msg", "회원가입에 실패했습니다.");

		}
		return mav;
	}

	@RequestMapping(value = "/self_introduce/write/{self_introduce_id}", method = RequestMethod.GET)
	public String write(UserVO vo, @PathVariable String self_introduce_id) {
		return "write";
	}

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(UserVO vo) {
		boolean result = service.logout();
		System.out.println(result);
		if(result)	return "redirect:/";
		else return "redirect:/";
	}

	@RequestMapping(value = "/mypage", method = RequestMethod.GET)
	public String mypage() {
		return "mypage";
	}
}
