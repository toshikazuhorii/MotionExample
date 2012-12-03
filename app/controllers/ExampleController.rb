class ExampleController < UIViewController
  CELL_REUSE_IDENTIFIER = 'cell'
  
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
    cell = tableView.dequeueReusableCellWithIdentifier(CELL_REUSE_IDENTIFIER) || begin
      UITableViewCell.alloc.initWithStyle(
        UITableViewCellStyleDefault,
        reuseIdentifier:CELL_REUSE_IDENTIFIER
      )
    end
    
    item = @data[indexPath.row]
    
    # text label
    image_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(item[:image_url]))
    image_view = UIImageView.alloc.initWithImage(UIImage.imageWithData(image_data))
    image_view.frame = CGRectMake(5, 5, 32, 32)
    cell.addSubview(image_view)
    
    # thumbnail
    label = UILabel.alloc.initWithFrame(CGRectMake(45, 10, 250, 20))
    label.font = UIFont.boldSystemFontOfSize(12)
    label.text = item[:name]
    cell.addSubview(label)
    
    return cell
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    @data.nil? ? 0 : @data.size
  end
end
