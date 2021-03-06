CREATE procedure [dbo].[spLessonGetByPage]
(
	@subjectId INT,
	@name NVARCHAR (250),
	@iSortCol INT=1,
	@sSortDir NVARCHAR(100)='asc',	 
	@pageNumber INT = 1,
	@pageSize INT = 10
)
AS
BEGIN
	SELECT Count(*) Over() AS TotalRows,
	 	l.LessonId,
		l.SubjectId,
		l.Name
	FROM   Lesson l
	WHERE   (l.SubjectId=@subjectId OR @subjectId IS NULL)
	AND (COALESCE(l.Name,'') LIKE '%' + COALESCE(@name, COALESCE(l.Name,'')) + '%')
	ORDER BY  CASE WHEN @iSortCol = 8 AND @sSortDir='asc' THEN l.SubjectId END asc,
		CASE WHEN @iSortCol = 8 AND @sSortDir='desc' THEN l.SubjectId END desc,
		CASE WHEN @iSortCol = 9 AND @sSortDir='asc' THEN l.Name END asc,
		CASE WHEN @iSortCol = 9 AND @sSortDir='desc' THEN l.Name END desc
	OFFSET (@pageNumber-1)*@pageSize ROWS
	FETCH NEXT @pageSize ROWS ONLY;
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spLessonAdd]
(
	@subjectId INT,
	@name NVARCHAR (250)
)
AS
BEGIN
	INSERT INTO Lesson ( SubjectId, Name )
	VALUES ( @subjectId, @name	)
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spLessonUpdate]
(
	@subjectId INT,
	@name NVARCHAR (250),
	@lessonId INT
)
AS
BEGIN
	UPDATE Lesson SET SubjectId=@subjectId, Name=@name
	WHERE LessonId=@lessonId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spLessonDelete]
(
	@lessonId INT
)
AS
BEGIN
	DELETE FROM Lesson
	WHERE 	LessonId = @lessonId
END

/*----------------------------------------------------------------------------*/

CREATE procedure [dbo].[spLessonGetAll]
(
)
AS
BEGIN
	SELECT 
	 	l.LessonId,
		l.SubjectId,
		l.Name
	FROM   Lesson l
END

/*----------------------------------------------------------------------------*/
