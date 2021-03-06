package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import vo.ProfileVO;
//import vo.UniversityVO;

@Repository
public class ProfileDAO {
	@Autowired
	SqlSession session;
	
	public List<ProfileVO> listAll(String userId, String category) {
		List<ProfileVO> list =
				session.selectList("resource."+category+"Mapper.listAll", userId);
		return list;
	}
	public int insert(ProfileVO vo, String category) {
		int result =
				session.insert("resource."+category+"Mapper.insert", vo);
		return result;
	}
	public int selectId(String category) {
		int result =
				session.selectOne("resource."+category+"Mapper.seqid");
		return result;
	}
	
	public int edit(ProfileVO vo, String category) {
		System.out.println("resource."+category+"Mapper.edit");
		System.out.println(vo.getId());
		System.out.println(vo.getUserId());
		int result =
				session.update("resource."+category+"Mapper.edit", vo);
		System.out.println("edit : "+result);
		return result;
	}
	public int delete(int id, String category){
		// TODO Auto-generated method stub
		int result = 
				session.delete("resource."+category+"Mapper.delete", id);
		
		return result;
	}

}
