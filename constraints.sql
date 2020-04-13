USE [Hotels Booking Manager]
GO
ALTER TABLE [Rooms]
ADD CONSTRAINT [CapacityCheck] CHECK([Capacity] >= 0)
GO
ALTER TABLE [Rooms]
ADD CONSTRAINT [PriceCheck] CHECK([Price] > 0.0)
GO
ALTER TABLE [Book]
ADD CONSTRAINT [HumanCheck] CHECK([QuantityOfHuman] > 0)