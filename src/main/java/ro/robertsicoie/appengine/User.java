package ro.robertsicoie.appengine;

import java.util.Date;

public class User {
    private String ip;
    private Date date;
    private String agent;

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public void setAgent(String agent) {
        this.agent = agent;
    }

    public String getAgent() {
        return agent;
    }

    @Override
    public String toString() {
        return "User{" +
                "ip='" + ip + '\'' +
                ", date=" + date +
                ", agent='" + agent + '\'' +
                '}';
    }
}
