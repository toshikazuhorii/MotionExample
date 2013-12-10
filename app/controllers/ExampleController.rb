class ExampleController < UIViewController
  CELL_REUSE_IDENTIFIER = 'Items'
  
  def viewDidLoad
    super
    
    # setup table view
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.dataSource = self
    @table.delegate = self
    self.view.addSubview(@table)
    
    # retrieving data
    @data = nil
    loaded_data_func = lambda { |data|
      @data = data
      @table.reloadData
    }
    ExampleData.retrieve_data(loaded_data_func)
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_REUSE_IDENTIFIER)
    
    if cell.nil?
      cell = ExampleCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:CELL_REUSE_IDENTIFIER
      )
      
      # thumbnail
      image_view = UIImageView.alloc.initWithFrame(CGRectMake(5, 5, 32, 32))
      cell.thumbnail = image_view
      cell.addSubview(image_view)
      
      # text label
      label = UILabel.alloc.initWithFrame(CGRectMake(45, 10, 250, 20))
      label.font = UIFont.boldSystemFontOfSize(12)
      cell.label = label
      cell.addSubview(label)
    end
    
    item = @data[indexPath.row]
    
    # thumbnail
    image_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(item[:image_url]))
    cell.thumbnail.image = UIImage.imageWithData(image_data)
    
    # text label
    cell.label.text = item[:name]
    
    return cell
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @data.nil? ? 0 : @data.size
  end
end
