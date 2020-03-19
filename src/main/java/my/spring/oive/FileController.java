package my.spring.oive;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.FileDAO;
import vo.FileVO;
import vo.UserVO;

@Controller
public class FileController {
	@Autowired
	ServletContext context; 
	
	@Autowired
	FileDAO uploadDAO;
	
	@Autowired
	HttpSession httpSession;
	
	
	public String createFilePath(String userId) {
		return context.getRealPath("/") + "resources/" + userId;
	}
	
	@RequestMapping(value="upload", method = RequestMethod.GET)
	public void upload(Model model) {
		model.addAttribute("filelist",uploadDAO.selectFileList());
	}
	
	@RequestMapping(value="upload", method = RequestMethod.POST, produces="application/json; charset=utf-8")
	@ResponseBody
	public String uploadFile(FileVO vo, Model model) {	
		vo.setUserId(((UserVO)httpSession.getAttribute("user")).getUserId());
		vo.setFileName(vo.getUploadFile().getOriginalFilename());
		
		System.out.println(vo.getUserId());
		
		String filepath = createFilePath(vo.getUserId());
		System.out.println("파일 디렉토리 : " + filepath);
		
		File dir = new File(filepath);

		
		if(!dir.isDirectory()) {
			dir.mkdir();
		}
		
		String filename = filepath + "/" + vo.getFileName();
		System.out.println("파일명 : " + filename);
		
		String msg = "";
		try{
			File file = new File(filename);
			if(file.exists()) {
				msg = "이미 존재하는 파일입니다.";
			}
			else {
				vo.getUploadFile().transferTo(file);
				msg ="파일이 저장되었습니다.";
				uploadDAO.uploadFile(vo);
			}
			
		} catch(IOException e) {
			e.printStackTrace();
			msg = "파일 저장에 실패하였습니다.";
		}


	    return String.format("{\"msg\":\"%s\"}", msg); // 문자 합치기
	}

	@RequestMapping(value="/download")
	@ResponseBody
	public ResponseEntity<Object> download(FileVO vo, HttpServletRequest request, HttpServletResponse response) {
		HttpHeaders headers = new HttpHeaders();
		HttpStatus status = null;
		Object body = null;
		
		vo.setUserId(((UserVO)httpSession.getAttribute("user")).getUserId());
		String filepath = createFilePath(vo.getUserId());
		String filename = vo.getFileName();
		System.out.println(filename);
		File file = new File(filepath + "/" + filename);
		
		
		boolean possible = true;
		boolean result = true;
        if(!file.exists()) possible = false;
		String client = request.getHeader("User-Agent");
                
        if(possible) {
        	
            //파일 다운로드 헤더 지정 
            headers.setContentType(MediaType.parseMediaType("application/octet-stream"));
            headers.setContentDisposition(ContentDisposition.builder("attachment").filename(filename, Charset.forName("UTF-8")).build());
            
        	try(InputStream in = new FileInputStream(file);) {
//        		throw new IOException();
	            if (client.indexOf("MSIE") != -1) {
	            	headers.setContentDisposition(ContentDisposition.builder("attachment").filename(filename, Charset.forName("UTF-8")).build());
	            	// IE 11 이상.
	            } else if (client.indexOf("Trident") != -1) {
	            	headers.setContentDisposition(ContentDisposition.builder("attachment").filename(filename, Charset.forName("UTF-8")).build());
	            } else {
	                // 한글 파일명 처리
	            	headers.setContentDisposition(ContentDisposition.builder("attachment").filename(filename, Charset.forName("ISO-8859-1")).build());
	                headers.setContentType(new MediaType("application","octet-stream",Charset.forName("UTF-8")));
	            }
	            headers.setContentLength(file.length());
	            
	            byte b[] = new byte[(int) file.length()];
	            while ((in.read(b)) > 0) {
	            }
	            
        		body = b;
	            status = HttpStatus.OK;
        	}catch(UnsupportedEncodingException e) {
        		e.printStackTrace();
        		headers.setContentType(new MediaType("application","json",Charset.forName("UTF-8")));
        		result = false;
        		status = HttpStatus.BAD_REQUEST;
        		body = "{\"msg\":\"잘못된 인코딩 방식을 적용하여 파일을 다운로드할 수 없습니다.\"}";
        	}catch (IOException e) {
        		e.printStackTrace();
        		headers.setContentType(new MediaType("application","json",Charset.forName("UTF-8")));
        		result = false;
        		status = HttpStatus.INTERNAL_SERVER_ERROR;
        		body = "{\"msg\":\"파일을 읽는 중 오류가 발생했습니다. 다시 한 번 시도해주세요.\"}";
  			}
        }
        else {
        	headers.setContentType(new MediaType("application","json",Charset.forName("UTF-8")));
        	result = false;
        	status = HttpStatus.NOT_FOUND;
        	body = "{\"msg\":\"파일을 찾을 수 없습니다\"}";
        }
        ResponseEntity<Object> entity = new ResponseEntity<Object>(body, headers, status);

        return entity;
	}
	@RequestMapping(value="delete")
	@ResponseBody
	public String deleteFile(FileVO vo) {
		vo.setUserId(((UserVO)httpSession.getAttribute("user")).getUserId());
		String filepath = createFilePath(vo.getUserId());
		String filename = vo.getFileName();
		System.out.println(filename);
		File file = new File(filepath + "/" + filename);
				
		boolean isfileExist = true;;
        if(!file.exists()) isfileExist = false;
        
        boolean isDeleteSucceed = uploadDAO.deleteFile(vo);
        
        boolean result = false;
        if(isfileExist && isDeleteSucceed) {
        	result = file.delete();
        }
        
        System.out.println("파일 존재 여부 : " + isfileExist);
        System.out.println("DAO 성공 여부 : " + isDeleteSucceed);
        System.out.println("파일시스템에서 삭제 : "+ result);
        
        return String.format("{\"result\" : \"%s\"}", ""+result);
	}
}
