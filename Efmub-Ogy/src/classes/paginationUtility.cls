public class paginationUtility 
{
    public Integer index {get;set;}    
    //current page number
    public Integer pageNum {get;set;}    
    //number of pages
    public Integer totalPage {get;set;}    
    //varialbe to hold number of record to paginate
    public Integer totalResults {get;set;}  
    //list of pages with active flag
    public List<Pager> pageList {get;set;}
    //variable returns true is previous page exists
    public Boolean showPrevious {get;set;}
    //variable return true is next page exists
    public Boolean showNext {get;set;}  
    //varialbe return true is all records fits on 1 page
    public Boolean isAll {get;set;}
    
    /**
    *paginationUtility  constructor.  
    *passed as parameters
    *@param listSize-total number of records to paginate
    *@param pageSize - number of records on single page
    */  
    public paginationUtility (Integer listSize, Integer pageSize)
    {
        this.totalResults = listSize;
        
        //if pageSize parameters less than 0, default to 10 records on the page
        pageSize = (pageSize > 0)?pageSize:10;
        
        //number of the pages
        this.totalPage = (Integer)Math.ceil((Double)listSize / (Double)pageSize);
        
        //set first page as a current page
        this.pageNum = 1;
        this.index = 0;
        
        //set isAll varialbe to true if all records fits on 1 page
        this.isAll = (listSize == pageSize)?true:false;
        updateNumbers();
    }
    
    /**
    * Method to update show previous, showNext variable and list of pages after 
    * user goes to previous or next page
    */ 
    public void updateNumbers()
    {
        this.pageList = new List<Pager>();
        //go through the pages and create list of Pager class with number of the page and isActive flag
        for(Integer i = 1; i < (this.totalPage + 1); i++)
        {
            //check if the current page isActive
            Boolean b = (i == pageNum)?true:false;
            this.pageList.add(new Pager(i, b));
        }
        //set showPrevious variable to true if previous page exists
        this.showPrevious = (this.pageNum == 1)?false:true;
        
        //set showNext variable to true if next page exists
        this.showNext = (this.pageNum == this.totalPage)?false:true;
        this.index = this.pageNum - 1;
    }
    
    /**
    * Method to go to the previous page
    */     
    public void decrement()
    {
        this.pageNum = this.pageNum - 1;
        updateNumbers();
    }
    
    /**
    * Method to go to the next page
    */ 
    public void increment()
    {
        this.pageNum++;
        updateNumbers();
    }
    
    /**
    * Inner class with pageNumber and isActive flag if page is a current page
    */ 
    public class Pager
    {
        public Integer pageNum {get;set;}
        public Boolean isActive {get;set;}
        
        /**
        * Pager constructor 
        * @param num - number of a page
        * @param active - flag if page is a current page.
        */ 
        public Pager(Integer num, Boolean active)
        {
            this.pageNum = num;
            this.isActive = active;
        }
    }
}