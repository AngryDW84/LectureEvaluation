//JavaMail URL
//http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-eeplat-419426.html#javamail-1.4.5-oth-JPR

//JavaBeans Activation Framework URL
//http://www.oracle.com/technetwork/java/javasebusiness/downloads/java-archive-downloads-java-plat-419418.html#jaf-1.1.1-fcs-oth-JPR
package util;

import javax.mail.PasswordAuthentication;

import javax.mail.Authenticator ; 

public class Gmail extends Authenticator{

	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("06sinji@gmail.com","!@12qwaszx") ; 
	}
	
}
