public class FlightLegInfoController{

 private final case ca;
    
    public FlightLegInfoController(ApexPages.StandardController stdController) {
        this.ca= (case)stdController.getRecord();
    }
    
    public pagereference rediectPage()
    {
      pagereference pg = new pagereference('/apex/SkyFinderFlightLegPage?id='+ca.id);
      pg.setRedirect(true);
      return pg;
    }
}