package post;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class Posta {

	private final Integer zip;
	private final List<PostaFiok> posts;
	
	private final Map<Integer, Posta> redirections;

    public Posta(Integer zip, List<PostaFiok> posts) {
        this.zip = zip;
        this.posts = posts;
        
        this.redirections = new HashMap<>();
    }

    public void sendLetter(Letter letter) {  
    	if (letter.isNotSendable()) {
    		throw new IllegalArgumentException();
    	}
    	
    	
    	if (zip.equals(letter.getZip())) {
    		Random rnd = new Random();
    		posts.get(rnd.nextInt(posts.size())).add(letter.increaseDay());
    	} else {
    		redirections.entrySet().stream()
    			.filter(r -> r.getKey().equals(letter.getZip()))
    			.map(r -> r.getValue())
    			.findFirst()
    			.ifPresentOrElse(
    					p -> p.sendLetter(letter.increaseDay()),
    					() -> letter.setAsNotSenable());
    	}
    }
    
    public Posta addRedirection(Integer zip, Posta posta) {
    	this.redirections.put(zip, posta);
    	
    	return this;
    }

    @Override
    public String toString() {
        return "ZIP: %s".formatted(zip);
    }
}
