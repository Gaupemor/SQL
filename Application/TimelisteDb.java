import java.sql.*;
import java.util.*;

//selmafs

public class TimelisteDb {
    private Connection connection;

    public TimelisteDb(Connection connection) {
        this.connection = connection;
    }

    public void printTimelister() throws SQLException {
		String q = "SELECT timelistenr, status, beskrivelse FROM Tliste;";
		ResultSet tlisteInfo = connection.createStatement().executeQuery(q);
	
		while(tlisteInfo.next()) {
			System.out.printf("%-2d: %-9s %s\n", tlisteInfo.getInt("timelistenr"), tlisteInfo.getString("status"), tlisteInfo.getString("beskrivelse"));
		}
    }

    public void printTimelistelinjer(int timelisteNr) throws SQLException {
		String q = "SELECT linjenr, timeantall, beskrivelse, kumulativt_timeantall FROM Tlistelinje WHERE timelistenr = " + timelisteNr + ";";
		ResultSet tlistelinjeInfo = connection.createStatement().executeQuery(q);

		while(tlistelinjeInfo.next()) {
			System.out.printf("%-2d: %-3d t (%-3d kumulativt) %s\n", tlistelinjeInfo.getInt("linjenr"), tlistelinjeInfo.getInt("timeantall"), tlistelinjeInfo.getInt("kumulativt_timeantall"), tlistelinjeInfo.getString("beskrivelse"));
		}
    }

    public double medianTimeantall(int timelisteNr) throws SQLException {
		String q = "SELECT timeantall FROM Tlistelinje WHERE timelistenr = " + timelisteNr + " ORDER BY timeantall ASC";
		ResultSet timeantall = connection.createStatement().executeQuery(q);

		ArrayList<Integer> l = new ArrayList<Integer>();
		while(timeantall.next()) {
			l.add(timeantall.getInt("timeantall"));
		}
        return median(l);
    }

    public void settInnTimelistelinje(int timelisteNr, int antallTimer, String beskrivelse) throws SQLException {
		//Noesta SELECT gjev maksverdien av linjenr for timelista
		String q = "INSERT INTO Tlistelinje (timelistenr, linjenr, timeantall, beskrivelse) VALUES (" + timelisteNr + ", (SELECT MAX(linjenr) FROM Tlistelinje WHERE timelistenr = " + timelisteNr +") + 1, " + antallTimer + ", '" + beskrivelse +"');";
		//executeUpdate() for aa unngaa feil: "No results returned by the query"
		connection.createStatement().executeUpdate(q);
    }

    public void regnUtKumulativtTimeantall(int timelisteNr) throws SQLException {
		//ORDER BY i tilfelle ukorrekt rekkefylgje
		String q = "SELECT timeantall, linjenr FROM Tlistelinje WHERE timelistenr = " + timelisteNr + " ORDER BY linjenr ASC;";
		ResultSet timeantall = connection.createStatement().executeQuery(q);

		//kumulativ
		int k = 0;
		while(timeantall.next()) {
			k += timeantall.getInt("timeantall");
			connection.createStatement().executeUpdate("UPDATE Tlistelinje SET kumulativt_timeantall = " + k + " WHERE  linjenr = " + timeantall.getInt("linjenr") + ";");
		}
    }

    /**
     * Hjelpemetode som regner ut medianverdien i en SORTERT liste. Kan slettes om du ikke har bruk for den.
     * @param list Tar inn en sortert liste av integers (f.eks. ArrayList, LinkedList osv)
     * @return medianverdien til denne listen
     */
    private double median(List<Integer> list) {
        int length = list.size();
        if (length % 2 == 0) {
            return (list.get(length / 2) + list.get(length / 2 - 1)) / 2.0;
        } else {
            return list.get((length - 1) / 2);
        }
    }
}
